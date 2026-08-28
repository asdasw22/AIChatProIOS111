import SwiftUI

struct CleanupView: View {
    @ObservedObject var manager: BackupManager
    @State private var showingConfirmation = false

    var body: some View {
        NavigationStack {
            List {
                Section("حذف آمن") {
                    Text("سيعرض هذا القسم حذف الصور التي تم رفعها وتأكيدها فقط. سيطلب iOS موافقتك، وقد يؤثر الحذف على iCloud Photos.")
                    Button("حذف الصور المرفوعة والمؤكدة") { showingConfirmation = true }
                        .foregroundStyle(.red)
                    Text(manager.message).font(.footnote).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("التنظيف")
            .confirmationDialog("هل تريد حذف الصور المرفوعة والمؤكدة من مكتبة الصور؟", isPresented: $showingConfirmation, titleVisibility: .visible) {
                Button("حذف", role: .destructive) {
                    let assets = manager.uploadedAssets()
                    Task { await manager.deleteUploadedAssets(assets) }
                }
                Button("إلغاء", role: .cancel) {}
            } message: {
                Text("لا تستخدم هذا الخيار إلا بعد التأكد من أن الصور موجودة في Telegram. إذا كانت iCloud Photos مفعلة فقد تُحذف من iCloud أيضًا.")
            }
        }
    }
}