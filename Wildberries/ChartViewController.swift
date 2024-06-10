import UIKit
protocol CartViewDelegate: AnyObject {
    func changeChart(with articlesInChart: [String: Int])
}

final class ChartViewController: UIViewController {
    weak var delegate: CartViewDelegate?
    private var articlesViewController: ArticlesViewController?
    private lazy var panelView: CartPanelView = {
        $0.translatesAutoresizingMaskIntoConstraints = false

        return $0
    }(CartPanelView())
    private var articlesInCart: [String: Int]
    private var articles: [Article]
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
        isModalInPresentation = true
        setupNavigationBar()
        setupPanelView()
        setupArticlesViewController()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Cart"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.delegate?.changeChart(with: self.articlesViewController?.articlesInCart ?? [:])
            self.dismiss(animated: true)
        })
    }
    
    private func setupPanelView() {
        view.addSubview(panelView)
        NSLayoutConstraint.activate([
            panelView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panelView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            panelView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panelView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func setupArticlesViewController() {
        articlesViewController = ArticlesViewController(articles: articles, articlesInCart: self.articlesInCart)
        if let articlesViewController {
            articlesViewController.willMove(toParent: self)
            addChild(articlesViewController)
            view.addSubview(articlesViewController.view)
            articlesViewController.didMove(toParent: self)
            articlesViewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                articlesViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                articlesViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                articlesViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                articlesViewController.view.bottomAnchor.constraint(equalTo: panelView.topAnchor)
            ])
        }
    }
}
