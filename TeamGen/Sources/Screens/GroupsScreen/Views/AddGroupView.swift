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

        addSubview(addButton)
        
        addButton.centerInSuperview()
        self.height(min: 100, priority: .defaultHigh, isActive: true)
    }
}

