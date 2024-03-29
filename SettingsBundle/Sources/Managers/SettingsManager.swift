//	MIT License
//
//	Copyright © 2019 Emile, Blue Ant Corp
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.
//
//	ID: 0D54B58E-0BF4-484F-83E3-78CAE4A9B720
//
//	Pkg: SettingsBundle
//
//	Swift: 5.0 
//
//	MacOS: 10.15
//

import Foundation

struct SettingsManager {
	
	public static let shared = SettingsManager()
	
	private enum Settings: String {
		case reset = "reset_preference"
	}
	
	enum Environment: String {
		case production
		case staging
		case development
	}
	
	init() {
		let appDefaults = [String: AnyObject]()
		UserDefaults.standard.register(defaults: appDefaults)
	}
	
	func checkAndExecuteSettings() {
		
		// Reset App
		if UserDefaults.standard.bool(forKey: Settings.reset.rawValue) {
			
			// reset userDefaults..
			removePersistentDomain()
			
			// Delete all user data here..
			// CoreDataModel.shared.deleteAll()
			// FileManager.shared.deleteAll()
			
			// Complete reset operation
			UserDefaults.standard.set(false, forKey: Settings.reset.rawValue)
			UserDefaults.standard.synchronize()
		}
	}
	
	// Get preferred enviroment
	func preferredEnvironment() -> Environment {
		if let env = UserDefaults.standard.string(forKey: "environment") {
			return Environment(rawValue: env)!
		}
		return Environment.production
	}
	
	// Get enviroment
	func enviromentUrl(_ environment: Environment) -> URL? {
		if let path = Bundle.main.url(forResource: "Environment", withExtension: "plist"),
			let data = try? Data(contentsOf: path) {
			if let result = try? PropertyListDecoder().decode([String: String].self, from: data) {
				return URL(string: result[environment.rawValue] ?? "")
			}
		}
		return nil
	}
	
	// Remove all UserDefaults data
	private func removePersistentDomain() {
		let appDomain: String? = Bundle.main.bundleIdentifier
		UserDefaults.standard.removePersistentDomain(forName: appDomain!)
	}
}
