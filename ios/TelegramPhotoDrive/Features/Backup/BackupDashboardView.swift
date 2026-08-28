import SwiftUI

struct BackupDashboardView: View {
    @ObservedObject var manager: BackupManager

    var body: some View {
        NavigationStack {
            List {
                Section("الحالة") {
                    LabeledContent("المجموع", value: "\(manager.stats.total)")
                    LabeledContent("معلقة", value: "\(manager.stats.pending)")
                    LabeledContent("قيد الرفع", value: "\(manager.stats.uploading)")
                    LabeledContent("مرفوعة", value: "\(manager.stats.uploaded)")
                    LabeledContent("فاشلة", value: "\(manager.stats.failed)")
                    Text(manager.message).font(.footnote).foregroundStyle(.secondary)
                }

                Section("الأوامر") {
                    Button("طلب صلاحية الصور") { Task { await manager.requestPhotosAccess() } }
                    Button("فهرسة الصور") { manager.indexLibrary() }
                    Button(manager.isRunning ? "إيقاف مؤقت" : "بدء/استكمال النسخ") {
                        manager.isRunning ? manager.stopBackup() : manager.startBackup()
                    }
                    Button("تحديث الإحصائيات") { manager.refreshStats() }
                }
            }
            .navigationTitle("النسخ الاحتياطي")
        }
    }
}