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
        setupSubViews()
    }
    
    private func setupSubViews() {
        let spinner = UIActivityIndicatorView()
        spinner.activityIndicatorViewStyle = .gray
        
        spinner.startAnimating()
        
        let content = UIStackView(arrangedSubviews: [spinner])
        content.alignment = .center
        content.axis = .horizontal
        content.distribution = .fillProportionally
        content.translatesAutoresizingMaskIntoConstraints = false
        addSubview(content)
        
        content.height(min: 100, priority: .defaultHigh, isActive: true)
        content.edgesToSuperview(usingSafeArea: true)
    }
}
