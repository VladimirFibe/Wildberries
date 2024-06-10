import UIKit

class ArticlesViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Article>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Article>
    
    enum Section {
        case main
    }
    
    private var articles: [Article]
    private lazy var dataSource = makeDataSouce()
    private(set) var articlesInCart: [String: Int]
    
    private lazy var collectionView: UICollectionView = {
        let layout = makeLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(articles: [Article], articlesInCart: [String: Int]) {
        self.articles = articles
        self.articlesInCart = articlesInCart
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
            
            let controller = ChartViewController(articles: self.articles.filter {
                if let count = self.articlesInCart[$0.id] {
                    return count != 0
                } else {
                    return false
                }
            }, articlesInCart: self.articlesInCart)
            controller.delegate = self
            self.present(UINavigationController(rootViewController: controller), animated: true)
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
        applySnapshot(animatingDifferences: false)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}

// MARK: - DataSource Implementation
extension ArticlesViewController {
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(articles)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private func makeDataSouce() -> DataSource {
        collectionView.register(WBCell.self, forCellWithReuseIdentifier: WBCell.identifier)
        return DataSource(collectionView: collectionView) { collectionView, indexPath, article in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WBCell.identifier,
                                                                for: indexPath) as? WBCell else { fatalError()}
            cell.configure(with: article, count: self.articlesInCart[article.id] ?? 0) {
                self.didTapAddButton(for: article)
            } didStepperChanded: { count in
                self.didStepperChanged(for: article, and: count)
            }

            return cell
        }
    }
    
    private func didTapAddButton(for article: Article) -> Int {
        if let count = articlesInCart[article.id] {
            articlesInCart[article.id] = count == 0 ? 1 : 0
        } else {
            articlesInCart[article.id] = 1
        }
        return articlesInCart[article.id] ?? 0
    }
    
    private func didStepperChanged(for article: Article, and count: Int) -> Int {
        articlesInCart[article.id] = count
        return articlesInCart[article.id] ?? 0
    }
}
// MARK: - Layout Implementation
extension ArticlesViewController {
    func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
            let item = NSCollectionLayoutItem(layoutSize: size)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: size, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 10
            return section
        }
        return layout
    }
}

extension ArticlesViewController: CartViewDelegate {
    func changeChart(with articlesInChart: [String : Int]) {
        self.articlesInCart = articlesInChart
        self.collectionView.reloadData()
    }
}
