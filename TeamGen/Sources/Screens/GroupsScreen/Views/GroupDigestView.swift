import UIKit
import TeamGenFoundation

final class GroupDigestView: UIView, ReusableView {
    
    init(group: GroupDigestViewModel, frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
