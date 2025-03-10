//
//  ListTableView.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 5.03.2025.
//

import UIKit

class ListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel: ListViewModel
    
    init(frame: CGRect, style: UITableView.Style, viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame, style: style)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTableView() {
        self.backgroundColor = .clear
        self.dataSource = self
        self.delegate = self
        self.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as! ListCell
        let item = viewModel.items[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, view, completionHandler) in
            self.viewModel.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        deleteAction.backgroundColor = .back
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
}
