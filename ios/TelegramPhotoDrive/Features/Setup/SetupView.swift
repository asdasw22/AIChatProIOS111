import SwiftUI
import Photos

struct SetupView: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var botToken = ""
    @State private var statusMessage = ""
    private let keychain = KeychainService()

    var body: some View {
        NavigationStack {
            Form {
                Section("Telegram") {
                    SecureField("توكن البوت من BotFather", text: $botToken)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Telegram Chat ID / أيدي المستخدم", text: $settings.telegramChatID)
                        .keyboardType(.numberPad)
                    Button("حفظ التوكن والإعدادات") { saveSettings() }
                        .disabled(botToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || settings.telegramChatID.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    if settings.isConfigured { Label("الإعدادات جاهزة", systemImage: "checkmark.seal.fill") }
                }

                Section("الخيارات") {
                    Toggle("الرفع عبر Wi‑Fi فقط", isOn: $settings.wifiOnly)
                }

                Section("تنبيهات مهمة") {
                    Text("التطبيق سيرسل الصور مباشرةً إلى Telegram Bot API باستخدام التوكن والأيدي اللذين تحفظهما هنا.")
                    Text("توكن البوت يُحفظ في Keychain على الجهاز، ولا يوضع داخل ملفات المشروع.")
                    Text("iOS لا يضمن العمل المستمر في الخلفية، وسيكمل التطبيق عند إعادة فتحه من آخر عناصر غير مرفوعة.")
                    Text("لا تحذف الصور إلا بعد التأكد من النسخة الاحتياطية. الحذف قد يؤثر على iCloud Photos.")
                }

                if !statusMessage.isEmpty { Section { Text(statusMessage) } }
            }
            .navigationTitle("الإعداد")
            .onAppear { botToken = (try? keychain.readToken()) ?? "" }
        }
    }

    private func saveSettings() {
        do {
            try keychain.saveToken(botToken.trimmingCharacters(in: .whitespacesAndNewlines))
            settings.hasBotToken = true
            statusMessage = "تم حفظ توكن البوت وChat ID"
        } catch {
            statusMessage = error.localizedDescription
        }
    }
}