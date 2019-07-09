//
//  Copyright © 2019 silonk
//  All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func postRequestInBackground() {
        guard let request = HTTPClient.shared.postImageRequest(), let data = request.httpBody else { return }
        BackgroundSessionManager.shared.start(request, data: data)
    }
    
    //Outlet & Target Actions
    @objc private func applicationDidEnterBackground() {
        print("application did enter background")
        postRequestInBackground()
    }
}
