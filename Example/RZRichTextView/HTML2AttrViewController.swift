//
//  HTML2AttrViewController.swift
//  RZRichTextView_Example
//
//  Created by rztime on 2023/7/26.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import QuicklySwift
import RZRichTextView

class HTML2AttrViewController: UIViewController {

    let textView = RZRichTextView.init(frame: .init(x: 15, y: 0, width: qscreenwidth - 30, height: 300), viewModel: .shared(edit: true))
        .qbackgroundColor(.qhex(0xf5f5f5))
        .qplaceholder("请输入内容")
    let label = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.qbody([
            textView.qmakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalToSuperview().inset(100)
                make.height.equalTo(300)
            }),
            label.qmakeConstraints({ make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview().inset(100)
            })
        ])
        let btn = UIButton.init(type: .custom)
            .qtitle("转html")
            .qtitleColor(.red)
            .qtap { [weak self] view in
                guard let self = self else { return }
                let attachments = self.textView.attachments
                if let _ = attachments.firstIndex(where: { info in
                    if case .complete(let success, _) = info.uploadStatus.value {
                        return !success
                    }
                    return true
                }) {
                    // 有未完成上传的
                    print("有未完成上传的")
                    return
                }
                let h = self.textView.attributedText.rz.codingToCompleteHtml()!
                print("\(h)")
                let html = self.textView.code2html()
//                print("\(html)")
            }
        
        /// 上传完成时，可以点击
        textView.viewModel.uploadAttachmentsComplete.subscribe({ [weak btn] value in
            btn?.isEnabled = value
            btn?.alpha = value ? 1 : 0.3
        }, disposebag: btn)
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        
        let html = try? String.init(contentsOfFile: "/Users/rztime/Desktop/test.html")
        textView.html2Attributedstring(html: html)

    }
}
