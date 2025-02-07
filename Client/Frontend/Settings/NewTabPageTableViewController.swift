// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import Foundation
import Static
import BraveShared
import Shared

class NewTabPageTableViewController: TableViewController {
    let sponsoredRow = BoolRow(title: Strings.NewTabPageSettingsSponsoredImages, option: Preferences.NewTabPage.backgroundSponsoredImages)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hides unnecessary empty rows
        tableView.tableFooterView = UIView()
        
        navigationItem.title = Strings.NewTabPageSettingsTitle
        tableView.accessibilityIdentifier = "NewTabPageSettings.tableView"
        dataSource.sections = [section]
        
        // Sponsored switch is only enabled if the background images is enabled also.
        self.sponsoredSwitch?.isEnabled = Preferences.NewTabPage.backgroundImages.value
    }
    
    private lazy var section: Section = {
        var rows = [
            BoolRow(title: Strings.NewTabPageSettingsBackgroundImages, option: Preferences.NewTabPage.backgroundImages, onValueChange: {
                newValue in
                // Since overriding, does not auto-adjust this setting.
                Preferences.NewTabPage.backgroundImages.value = newValue
                
                // If turning off normal background images, turn of sponsored images as well.
                Preferences.NewTabPage.backgroundSponsoredImages.value = newValue
                
                if !newValue {
                    // Updating the underlying preference does not dynamically update the visuals unfortuantely.
                    // Updating manually. Only update if disabling.
                    self.sponsoredSwitch?.isOn = newValue
                }
                
                // Need to update every time.
                self.sponsoredSwitch?.isEnabled = newValue
            })
        ]
        
        if BackgroundImage.showSponsoredSetting {
            rows.append(sponsoredRow)
        }
        
        rows.append(BoolRow(title: Strings.NewTabPageSettingsAutoOpenKeyboard, option: Preferences.NewTabPage.autoOpenKeyboard))
        return Section(rows: rows)
    }()
    
    private var sponsoredSwitch: UISwitch? {
        return sponsoredRow.accessory.view as? SwitchAccessoryView
    }
}
