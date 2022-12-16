import RealmSwift

public class DatabaseManager {
    public static func openDB() {
        let rootDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = rootDirectoryURL.appendingPathComponent("data.realm")
        let configuration = Realm.Configuration(fileURL: fileURL, deleteRealmIfMigrationNeeded: true)

        let realm =  try! Realm(configuration: configuration)
        let models = realm.objects(MyModel.self)
        if models.count > 0 {
            return print("read \(models.count) model(s) from DB")
        }

        try! realm.write {
            realm.create(MyModel.self)
        }

        print("model saved to DB")
    }
}
