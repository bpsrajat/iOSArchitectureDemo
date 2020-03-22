//
//  StoriesTableViewCell.swift
//  ArchitectureDemonstration
//
//  Copyright © 2020 Rajat Sharma. All rights reserved.
//

import UIKit
import PINRemoteImage

class StoryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        authorLabel.text = ""
        storyImage.layer.cornerRadius = 3.5
        storyImage.clipsToBounds = true
        selectionStyle = .none
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowOffset = .zero
        bgView.layer.shadowColor = UIColor.darkGray.cgColor
        bgView.layer.shadowRadius = 3
        bgView.layer.shouldRasterize = true
        bgView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setCell(story: Story) {
        titleLabel.text = story.title
        // MARK: Assuming name is the user name (display name), and fullname is their real name. We might not want to display their real names for privacy reasons.
        authorLabel.text = story.user.name.isEmpty ? "" : "By: \(story.user.name)"
        storyImage.pin_setPlaceholder(with: UIImage(named: "coverImage"))
    }
    
    override func prepareForReuse() {
        authorLabel.text = ""
        titleLabel.text = ""
        storyImage.pin_cancelImageDownload()
        storyImage.image = nil
    }
    
    
}
