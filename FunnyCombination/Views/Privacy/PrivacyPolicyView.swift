import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Privacy Policy")
                    .font(.title)
                    .bold()

                Text("""
                This is a placeholder Privacy Policy text.

                The application does not collect, store, or share any personal user data.
                All game results are stored locally on the device.

                This policy may be updated in the future.
                """)
                .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}
