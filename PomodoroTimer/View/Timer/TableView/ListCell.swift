//
//  ListCell.swift
//  PomodoroTimer
//
//  Created by Bayram Yeleç on 8.03.2025.
//

import UIKit

class ListCell: UITableViewCell {
    
    static let reuseIdentifier = "ListCell"
    
    private lazy var focusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var breakLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemYellow.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white.withAlphaComponent(0.7)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .black
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.addSubview(focusLabel)
        self.addSubview(breakLabel)
        self.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            focusLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            focusLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            
            breakLabel.topAnchor.constraint(equalTo: self.focusLabel.bottomAnchor, constant: 4),
            breakLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            breakLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with item: ListModel) {
        focusLabel.text = String(format: "Focus Time: %02d:%02d:%02d", item.focusTime / 3600, (item.focusTime % 3600) / 60, item.focusTime % 60)
        breakLabel.text = String(format: "Break Time: %02d:%02d:%02d", item.breakTime / 3600, (item.breakTime % 3600) / 60, item.breakTime % 60)
        dateLabel.text = dateFormatter().string(from: item.date)
    }
    
    private func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
}
