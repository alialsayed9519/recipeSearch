//
//  TableViewCell.swift
//  recipeSearch
//
//  Created by Ali on 09/08/2022.
//

import UIKit
import SDWebImage

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeSource: UILabel!
    @IBOutlet weak var healthLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateUi(recipe: Recipe) {
        recipeTitle?.text = recipe.title
        recipeSource?.text = recipe.source
        var labels = ""
        for i in recipe.healthLabels {
            labels.append("\(i) - ")
        }
        healthLabel.text = labels
        
        recipeImage.sd_setImage(with: URL(string: recipe.image), placeholderImage: UIImage(named: "recipeImage.png"))
    }
    
    func setupImageView() {
        recipeImage.layer.cornerRadius = recipeImage.frame.height/2
        recipeImage.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
    }

}
