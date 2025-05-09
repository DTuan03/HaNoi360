import UIKit
import SnapKit

class TestVC: UIViewController {
    
    lazy var mainScrollView = UIScrollView()
    
    lazy var contentView = UIView()
    
    lazy var iv = ImageViewFactory.createImageView(image: .intro1, contentMode: .scaleAspectFill)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .black
        mainScrollView.backgroundColor = .red
        contentView.backgroundColor = .green
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }

        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-60)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(mainScrollView)
            make.height.equalTo(1500)
        }
        
        contentView.addSubview(iv)
        iv.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
        }
    }
}
