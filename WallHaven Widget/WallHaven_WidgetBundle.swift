//
//  WallHaven_WidgetBundle.swift
//  WallHaven Widget
//
//  Created by Raeein Bagheri on 2023-12-21.
//

import WidgetKit
import SwiftUI

@main
struct WallHaven_WidgetBundle: WidgetBundle {
    var body: some Widget {
        WallHaven_Widget()
        WallHaven_WidgetLiveActivity()
    }
}
