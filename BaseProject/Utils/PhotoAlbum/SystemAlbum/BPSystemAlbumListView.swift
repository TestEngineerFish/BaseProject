//
//  BPSystemAlbumListView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/11.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos

protocol BPSystemAlbumListViewDelegate: NSObjectProtocol {
    func selectedAlbum(model: BPPhotoAlbumModel)
}

class BPSystemAlbumListView: BPView, UITableViewDelegate, UITableViewDataSource {

    let cellID = "kBPSystemAlbumCell"
    var albumList: [BPPhotoAlbumModel] = []
    var currentModel: BPPhotoAlbumModel?
    var tableViewHeight = CGFloat.zero

    weak var delegate: BPSystemAlbumListViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator   = false
        tableView.rowHeight       = AdaptSize(44)
        tableView.backgroundColor = .black2
        return tableView
    }()

    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isUserInteractionEnabled = true
        return view
    }()

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        self.addSubview(tableView)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

    }

    override func bindProperty() {
        super.bindProperty()
        self.layer.masksToBounds  = true
        self.tableView.register(BPSystemAlbumCell.classForCoder(), forCellReuseIdentifier: cellID)
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(hideView))
        self.backgroundView.addGestureRecognizer(tapAction)
    }

    // MARK: ==== Event ====

    func setData(albumList: [BPPhotoAlbumModel], current model: BPPhotoAlbumModel?) {
        self.albumList    = albumList
        self.currentModel = model
        tableViewHeight   = CGFloat(albumList.count) * AdaptSize(44)
        tableViewHeight   = tableViewHeight > AdaptSize(400) ? AdaptSize(400) : tableViewHeight
        tableView.snp.remakeConstraints { (make) in
            make.center.width.equalToSuperview()
            make.bottom.equalTo(backgroundView.snp.top)
            make.height.equalTo(tableViewHeight)
        }
    }

    func showView() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.backgroundView.layer.opacity = 1.0
            self.tableView.transform = CGAffineTransform(translationX: 0, y: self.tableViewHeight)
        }
    }

    @objc func hideView() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.backgroundView.layer.opacity = 0.0
            self.tableView.transform          = .identity
        } completion: { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? BPSystemAlbumCell else {
            return UITableViewCell()
        }
        let model = self.albumList[indexPath.row]
        let selected: Bool = {
            guard let _currentModel = self.currentModel else { return false }
            return _currentModel == model
        }()
        cell.setData(model: model, isCurrent: selected)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = self.albumList[indexPath.row]
        self.delegate?.selectedAlbum(model: album)
        self.hideView()
    }
}
