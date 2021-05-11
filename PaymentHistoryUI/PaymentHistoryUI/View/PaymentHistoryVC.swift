//
//  ViewController.swift
//  PaymentHistoryUI
//
//  Created by aseem kapoor on 08/05/21.
//

import UIKit

class PaymentHistoryVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    private(set) var historyArr = [History]()
    private(set) var transactionArr = [[History]]()
    
    var shouldScrollToBottom = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "SenderCell", bundle: Bundle.main), forCellWithReuseIdentifier: CellIds.sender.getRawValue())
        collectionView.register(UINib(nibName: "ReceiverCell", bundle: Bundle.main), forCellWithReuseIdentifier: CellIds.receiver.getRawValue())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchHistoryData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        if shouldScrollToBottom {
            shouldScrollToBottom = false
            scrollToBottom(animated: false)
        }
    }
     
    func scrollToBottom(animated: Bool) {
        view.layoutIfNeeded()
        collectionView.setContentOffset(bottomOffset(), animated: animated)
    }
     
    func bottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: max(-collectionView.contentInset.top, collectionView.contentSize.height - (collectionView.bounds.size.height - collectionView.contentInset.bottom)))
    }
    
    private func fetchHistoryData() {
        
        if let url = Bundle.main.url(forResource: "history", withExtension: "json") {
            print(url)
            do {
                
                let data = try Data.init(contentsOf: url)
                let decoder = JSONDecoder.init()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy'T'HH:mm"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                self.historyArr = try decoder.decode([History].self, from: data)
                groupDataByDate()
                self.collectionView.reloadData()
                self.collectionView.collectionViewLayout.invalidateLayout()
                
            } catch let err {
                print(err.localizedDescription)
                print(err)
            }
            
        }
    }
    
    private func groupTransactionsByDate() -> [Date: [History]] {
        let dict: [Date: [History]] = [:]
        return historyArr.reduce(into: dict) { result, history in
            var cal = Calendar(identifier: .gregorian)
            cal.timeZone = TimeZone(identifier: "UTC")!
            let dateComp = cal.dateComponents([.year, .month, .day], from: history.transactionDate)
            let date = cal.date(from: dateComp)
            result[date!, default: []].append(history)
        }
    }
    
    private func groupDataByDate() {
        let groupedDict = groupTransactionsByDate()
        
        print(groupedDict)
        
        groupedDict.keys.sorted().forEach { key in
            transactionArr.append(groupedDict[key] ?? [])
        }
        
        print(transactionArr.count)
        print(transactionArr)
    }

}

extension PaymentHistoryVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return transactionArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return transactionArr[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? HeaderReusableView else {
            return UICollectionReusableView()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YY"
        sectionHeader.sectionHeaderlabel.text = dateFormatter.string(from: transactionArr[indexPath.section][indexPath.row].transactionDate)
        
        return sectionHeader
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds(rawValue: transactionArr[indexPath.section][indexPath.row].direction)?.getRawValue() ?? CellIds.sender.getRawValue(), for: indexPath) as? TransactionCell else {
            return UICollectionViewCell()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YY hh:mm"
        
        let item = transactionArr[indexPath.section][indexPath.row]
        myCell.configure(amount: item.amount, status: TransactionStatus(rawValue: item.status)!, direction: TransactionDirection(rawValue: item.direction)!, transaction: item.transactionId)
        myCell.transactionDate.text = dateFormatter.string(from: transactionArr[indexPath.section][indexPath.row].transactionDate)
        
        return myCell
    }
    
}

extension PaymentHistoryVC: UICollectionViewDelegate {
    // when the user taps
}

extension PaymentHistoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: CGFloat(180))
    }
}

