import UIKit

final class WBCell: UICollectionViewCell {
    public static var identifier = "WBCell"
    private var count = 0 { didSet {updateUI()}}
    private var isDigital = false { didSet {updateUI()}}
    private var didTapAddButton: (() -> Int)?
    private var didStepperChanded: ((Int) -> Int)?
    private func updateUI() {
        addButton.setNeedsUpdateConfiguration()
        stepper.isHidden = !(!isDigital && count != 0)
        countLabel.isHidden = !(!isDigital && count != 0)
        countLabel.text = "\(count)"
    }
    
    private let coverView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let subtitleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let priceLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var stepper: UIStepper = {
        $0.addAction(UIAction { _ in
            if let count = self.didStepperChanded?(Int(self.stepper.value)) {
                self.count = count
            }
        }, for: .valueChanged)
        $0.isHidden = true
        $0.value = 0
        $0.minimumValue = 0
        $0.maximumValue = 100
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIStepper())
    
    private let countLabel: UILabel = {
        $0.text = "1"
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private lazy var addButton: UIButton = {
        let config = UIButton.Configuration.gray()
        $0.configuration = config
        $0.configurationUpdateHandler = { [unowned self] button in
            var config = button.configuration
            let symbolName = count == 0 ? "cart.badge.plus" : "cart.badge.minus"
            button.isHidden = !isDigital && count != 0
            config?.image = UIImage(systemName: symbolName)
            button.configuration = config
        }
        $0.addAction(UIAction { _ in
            if let count = self.didTapAddButton?() {
                self.count = count
                self.stepper.value = Double(count)
            }
        }, for: .primaryActionTriggered)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton(type: .system))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCoverView()
        setupAddButton()
        setupStepper()
        setupCountLabel()
        setupTitleLabel()
        setupSubtitleLabel()
        setupPriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCoverView() {
        contentView.addSubview(coverView)
        NSLayoutConstraint.activate([
            coverView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            coverView.widthAnchor.constraint(equalToConstant: 160),
            coverView.heightAnchor.constraint(equalTo: coverView.widthAnchor)
        ])
    }
    
    private func setupAddButton() {
        contentView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupStepper() {
        contentView.addSubview(stepper)
        NSLayoutConstraint.activate([
            stepper.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            stepper.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func setupCountLabel() {
        contentView.addSubview(countLabel)
        NSLayoutConstraint.activate([
            countLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            countLabel.trailingAnchor.constraint(equalTo: stepper.leadingAnchor, constant: -8)
        ])
    }
    
    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: coverView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor)
        ])
    }
    
    private func setupSubtitleLabel() {
        contentView.addSubview(subtitleLabel)
        NSLayoutConstraint.activate([
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    private func setupPriceLabel() {
        contentView.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 4),
            priceLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
    }
    
    public func configure(
        with article: Article,
        count: Int,
        didTapAddButton: (() -> Int)?,
        didStepperChanded: ((Int) -> Int)?
    ) {
        coverView.image = UIImage(named: article.image)
        self.count = count
        isDigital = article.isDigital
        subtitleLabel.text = article.subTitle
        titleLabel.text = article.title
        priceLabel.text = String(format: "%.0f tenge", article.cost)
        stepper.value = Double(count)
        self.didTapAddButton = didTapAddButton
        self.didStepperChanded = didStepperChanded
    }
}
