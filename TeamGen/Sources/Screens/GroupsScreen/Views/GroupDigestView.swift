import UIKit
import TeamGenFoundation
import TinyConstraints

final class GroupDigestView: UIView, ReusableView {
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with viewModel: GroupDigestViewModel) {
        super.init(frame: .zero)
        setupSubViews(with: viewModel)
    }
    
    private func setupSubViews(with viewModel: GroupDigestViewModel) {
        let title = UILabel()
        title.text = viewModel.title
        title.textAlignment = .left
        title.numberOfLines = 0
        
        let content = UIStackView(arrangedSubviews: [title])
        content.alignment = .fill
        content.axis = .horizontal
        content.distribution = .fillProportionally
        content.spacing = 10
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        
        content.height(min: 100, priority: .defaultHigh, isActive: true)
        content.edgesToSuperview(usingSafeArea: true)
    }
}
