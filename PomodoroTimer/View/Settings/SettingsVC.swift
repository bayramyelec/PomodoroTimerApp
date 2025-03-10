//
//  ListVC.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 26.02.2025.
//

struct SettingItem {
    let title: String
    let icon: UIImage?
    let action: (() -> Void)?
}

struct SettingsSection {
    let header: String
    var items: [SettingItem]
}

import UIKit

class SettingsVC: UIViewController {
    
    private var settings: [SettingsSection] = []
    
    var selectedSound: String = "defaultSound"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .back
        setupTableView()
        configureSettingsSections()
        title = "Settings"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.back
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.backgroundColor = .back
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureSettingsSections() {
        settings = [
            SettingsSection(header: "Notification Settings", items: [
                SettingItem(title: "Notification", icon: UIImage(systemName: "bell.fill"), action: {
                    self.chooseNotificationSound()
                })
            ]),
            SettingsSection(header: "Other", items: [
                SettingItem(title: "Instagram", icon: UIImage(systemName: "camera.viewfinder"), action: {
                    
                }),
                SettingItem(title: "LinkedIn", icon: UIImage(systemName: "l.square.fill"), action: {
                    
                }),
                SettingItem(title: "Github", icon: UIImage(systemName: "g.square.fill"), action: {
                    
                }),
                SettingItem(title: "X", icon: UIImage(systemName: "x.square.fill"), action: {
                    
                })
            ])
        ]
    }
    
    private func chooseNotificationSound() {
        let alert = UIAlertController(title: "Choose Notification Sound", message: "Select a sound for notifications", preferredStyle: .actionSheet)
        
        let soundOptions = ["Default", "Bell", "Chime"]
        
        for sound in soundOptions {
            alert.addAction(UIAlertAction(title: sound, style: .default, handler: { [weak self] action in
                self?.selectedSound = sound.lowercased()
                UserDefaults.standard.set(sound.lowercased(), forKey: "selectedSound")
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .back
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = settings[section].header
        label.textColor = .black
        label.font = .systemFont(ofSize: 16, weight: .bold)
        
        headerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = settings[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.imageView?.image = item.icon
        cell.imageView?.tintColor = .black
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = .back
        cell.textLabel?.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = settings[indexPath.section].items[indexPath.row]
        item.action?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .black
        }
    }
}
