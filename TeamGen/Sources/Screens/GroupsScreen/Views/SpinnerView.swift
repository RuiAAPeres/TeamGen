import UIKit
import TeamGenFoundation
import TinyConstraints

final class SpinnerView: UIView, ReusableView {
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .gray
        
        spinner.startAnimating()
        
        self.addSubview(spinner)
        spinner.centerInSuperview(usingSafeArea: true)
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
