import SwiftUI
import UIKit

struct AffirmationsView: View {
    
    @State private var affirmation = "You are a smart cookie."
    @AppStorage("firstName") private var firstName: String = "Name"
    @AppStorage("useNameInAffirmation") private var useNameInAffirmation: Bool = false
    @AppStorage("selectedColorTheme") private var selectedColorTheme: Int = 1
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if affirmation == "" {
                        ContentUnavailableView("Can't fetch a new affirmation. Verify your internet connection.", systemImage: "exclamationmark.triangle")
                    } else {
                        Text(affirmation)
                            .frame(height: UIScreen.main.bounds.height / 2)
                            .frame(maxWidth: .infinity)
                            .padding(20)
                            .background(ColorManager.colorFromIndex(index: selectedColorTheme))
                            .foregroundColor(.white)
                            .font(.system(size: 30, weight: .bold))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                    }
                    
                    
                    Text("Shake your iPhone to get a new affirmation")
                        .padding(.top)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .navigationTitle("Affirmations")
            .onShake {
                await getAffirmation()
            }
            
        }
        
    }
    
    private func getAffirmation() async {
        let endpoint = "https://www.affirmations.dev"
        guard let url = URL(string: endpoint) else {
            print("Endpoint does not work")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(Affirmation.self, from: data) {
                affirmation = decodedResponse.affirmation
                if useNameInAffirmation {
                    affirmation = "\(firstName), \(affirmation.lowercased())."
                }
            }
        } catch {
            affirmation = ""
        }
    }
}

struct Affirmation: Codable {
    let affirmation: String
}

extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name("deviceDidShakeNotification")
}


extension UIWindow {
    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
    }
}


struct DeviceShakeViewModifier: ViewModifier {
    let action: () async -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                Task {
                    await action()
                }
            }
    }
}

extension View {
    func onShake(perform action: @escaping () async -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

#Preview {
    AffirmationsView()
}

