//
//  HeaderViewUI.swift
//  Sanskar
//
//  Created by Sanskar IOS Dev on 25/04/26.
//  Copyright © 2026 MAC MINI. All rights reserved.
//
import SwiftUI
@MainActor
final class AppUIState: ObservableObject {
   
    @Published var showSearchScreen: Bool = false
    @Published var searchText: String = ""
}
struct NavBar: View {
    @Binding var presentSideMenu: Bool
    var notificationCount: Int = 0
    var searchPlaceholder: String = "Search..."
    @Binding var searchText: String   
    @EnvironmentObject var uiState: AppUIState
  
    var body: some View {
        VStack {

            if uiState.showSearchScreen {

                // 🔍 SEARCH MODE
                HStack {
                    Button {
                        withAnimation {
                            uiState.showSearchScreen = false
                            uiState.searchText = ""
                        }
                    } label: {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }

                    TextField(searchPlaceholder, text: $uiState.searchText)
                        .textFieldStyle(.plain)

                    if !uiState.searchText.isEmpty {
                        Button {
                            uiState.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
            } else {

                // 🔥 NORMAL HEADER
                HStack {
                    Button {
                        if let topVC = UIApplication.shared.topViewController,
                           let menu = topVC.slideMenuController() {
                            menu.openLeft()
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }

                    Image("Sanskarlogos")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)

                    Spacer()

                    Button {
                        withAnimation {
                            uiState.showSearchScreen = true
                        }
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .background(Color.white)
    }
}

import UIKit

extension UIApplication {
    
    var topViewController: UIViewController? {
        guard let scene = connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let root = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }
        return UIApplication.getTopViewController(from: root)
    }

    private static func getTopViewController(from vc: UIViewController) -> UIViewController {
        if let nav = vc as? UINavigationController {
            return getTopViewController(from: nav.visibleViewController ?? nav)
        }
        if let tab = vc as? UITabBarController {
            return getTopViewController(from: tab.selectedViewController ?? tab)
        }
        if let presented = vc.presentedViewController {
            return getTopViewController(from: presented)
        }
        return vc
    }
}

