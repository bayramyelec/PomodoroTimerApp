//
//  ListTableView.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 5.03.2025.
//

import UIKit

class ListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var viewModel = ListViewModel()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
        viewModel.reloadData = { [weak self] in
            self?.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        backgroundColor = .clear
        showsVerticalScrollIndicator = false
        delegate = self
        dataSource = self
        register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as! ListCell
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    
}
