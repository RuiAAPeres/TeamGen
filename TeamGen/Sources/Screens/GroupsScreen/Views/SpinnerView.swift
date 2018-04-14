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
        addSubview(spinner)
        
        spinner.centerInSuperview()
        self.height(min: 100, priority: .defaultHigh, isActive: true)
    }
}
