//
//  AppDelegater.swift
//  TTLang
//
//  Created by Yannis Lang on 20/03/2025.
//
import UIKit
import SwiftUI
import Combine
import Foundation

@MainActor
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var environment = AppEnvironment.bootstrap()

    var rootView: some View {
        environment.rootView
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}

