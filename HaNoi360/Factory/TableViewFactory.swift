//
//  TableViewFactory.swift
//  HaNoi360
//
//  Created by Tuấn on 7/4/25.
//

import UIKit

class TableViewFactory {
    static func createTableView() -> UITableView {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        tableView.separatorInset = .zero
        tableView.separatorColor = .gray
#if compiler(>=5.5)
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
#endif
        return tableView
    }
}
