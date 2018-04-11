import UIKit
import TeamGenFoundation
import TinyConstraints

final class AddGroupView: UIView, ReusableView {
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(with viewModel: AddGroupViewModel) {
        super.init(frame: .zero)
        setupSubViews(with: viewModel)
    }
    
    private func setupSubViews(with viewModel: AddGroupViewModel) {
        let addButton = UIButton()
        addButton.setTitle(viewModel.title, for: .normal)
        
        let content = UIStackView(arrangedSubviews: [addButton])
        content.alignment = .center
        content.axis = .horizontal
        content.distribution = .fillProportionally
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        
        content.height(min: 100, priority: .defaultHigh, isActive: true)
        content.edgesToSuperview(usingSafeArea: true)
    }
}

