//
//  WatchOnlyWalletInfoTableViewCell.swift
//  Decred Wallet
//
// Copyright (c) 2020 The Decred developers
// Use of this source code is governed by an ISC
// license that can be found in the LICENSE file.

import UIKit
import Dcrlibwallet

protocol WatchOnlyWalletInfoTableViewCellDelegate {
    func showWatchOnlyWalletDetailsDialog(_ wallet: Wallet)
    func showWatchOnlyWalletMenu(walletName: String, walletID: Int, type: DropDowMenuEnum)
    func indexDropdownOpen(index: IndexPath)
}

class WatchOnlyWalletInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var walletsSection: UIView!
    @IBOutlet weak var walletsTableView: UITableView!
    @IBOutlet weak var walletsTableViewHeightConstraint: NSLayoutConstraint!
    
    var delegate: WatchOnlyWalletInfoTableViewCellDelegate?
    
    static let walletInfoSectionHeight: CGFloat = 65.0
    static let walletCellHeight: CGFloat = 56.0
    
    var indexDropDownShow: IndexPath?
    var indexPath: IndexPath!
    
    var watchOnlywallet = [Wallet]() {
        didSet {
            self.walletsTableViewHeightConstraint.constant = self.accountsTableViewHeight
            
            if self.walletsTableView.delegate == nil {
                self.walletsTableView.dataSource = self
                self.walletsTableView.delegate = self
                self.walletsTableView.registerCellNib(WatchOnlyWalletTableViewCell.self)
            } else {
                self.walletsTableView.reloadData()
            }
        }
    }
    
    var numberOfWalletsToDisplay: Int {
        return self.watchOnlywallet.count
    }
    
    var accountsTableViewHeight: CGFloat {
        return CGFloat(self.numberOfWalletsToDisplay) * WatchOnlyWalletInfoTableViewCell.walletCellHeight
    }
    
    func closeDropdown() {
        guard let index = self.indexDropDownShow else {return}
        if let cell = self.walletsTableView.cellForRow(at: index) as? WatchOnlyWalletTableViewCell {
            cell.closeDropDown()
        }
    }
}

extension WatchOnlyWalletInfoTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfWalletsToDisplay
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return WatchOnlyWalletInfoTableViewCell.walletCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let accountViewCell = tableView.dequeueReusableCell(withIdentifier: "WatchOnlyWalletTableViewCell") as! WatchOnlyWalletTableViewCell
        accountViewCell.wallet = self.watchOnlywallet[indexPath.row]
        accountViewCell.delegate = self
        accountViewCell.indexPath = indexPath
        return accountViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.showWatchOnlyWalletDetailsDialog(self.watchOnlywallet[indexPath.row])
    }
}

extension WatchOnlyWalletInfoTableViewCell: WatchOnlyWalletTableViewCellDelegate {
    func indexDropdownOpen(index: IndexPath) {
        self.indexDropDownShow = index
        self.delegate?.indexDropdownOpen(index: self.indexPath)
    }
    
    func showWatchOnlyWalletMenu(walletName: String, walletID: Int, type: DropDowMenuEnum) {
        self.delegate?.showWatchOnlyWalletMenu(walletName: walletName, walletID: walletID, type: type)
    }
}
