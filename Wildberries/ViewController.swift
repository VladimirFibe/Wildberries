import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupCollectionView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Wildberries"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        let cartAction = UIAction { _ in
            let controller = UINavigationController(rootViewController: UIViewController())
            controller.view.backgroundColor = .systemBackground
            self.present(controller, animated: true)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cart",
            image: UIImage(systemName: "cart"),
            primaryAction: cartAction,
            menu: nil
        )
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .green
//        collectionView.collectionViewLayout = makeLayout()
//        applySnapshot(animatingDifferences: false)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

