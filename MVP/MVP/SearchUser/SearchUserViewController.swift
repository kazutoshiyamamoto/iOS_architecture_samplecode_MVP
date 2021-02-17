//
//  ViewController.swift
//  MVP
//
//  Created by home on 2020/06/25.
//  Copyright © 2020 Swift-beginners. All rights reserved.
//

import UIKit
import GitHub

final class SearchUserViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!

    // Presenterに実装されたUIの表示に必要なプロパティもしくはユーザーの操作によって発火する処理を呼び出したいため、
    // SearchUserPresenterInputを初期化する実装がある
    // ちなみに、SearchUserPresenterOutputを初期化しないのは、
    // SearchUserPresenterOutputの値にアクセスしたいわけではなく、
    // 単にSearchUserPresenterOutputに準拠したメソッドで個別のふるまいをViewで定義したいため
    private var presenter: SearchUserPresenterInput!
    func inject(presenter: SearchUserPresenterInput) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    private func setup() {
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
    }
}

extension SearchUserViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.didTapSearchButton(text: searchBar.text)
    }
}

extension SearchUserViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectRow(at: indexPath)
    }
}

extension SearchUserViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfUsers
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell

        if let user = presenter.user(forRow: indexPath.row) {
            cell.configure(user: user)
        }

        return cell
    }
}

extension SearchUserViewController: SearchUserPresenterOutput {
    func updateUsers(_ users: [User]) {
        tableView.reloadData()
    }

    func transitionToUserDetail(userName: String) {
        let userDetailVC = UIStoryboard(
            name: "UserDetail",
            bundle: nil)
            .instantiateInitialViewController() as! UserDetailViewController
        let model = UserDetailModel(userName: userName)
        let presenter = UserDetailPresenter(
            userName: userName,
            view: userDetailVC,
            model: model)
        userDetailVC.inject(presenter: presenter)

        navigationController?.pushViewController(userDetailVC, animated: true)
    }
}
