import CoreData
import UIKit

final class HabitRepositoryWorker {
    private let ctx = Persistence.shared.container.viewContext
    
    func fetchAll() throws -> [HabitVM.Habit] {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return try ticketsToTicketsVM(ctx.fetch(req))
    }
    
    func fetchCompletedHabits() throws -> [HabitVM.Habit] {
        let habits = try fetchAll()
        
        return habits.filter {
            return $0.isCompleted == true
        }
    }
    
    func fetchNotCompletedHabits() throws -> [HabitVM.Habit] {
        let habits = try fetchAll()
        
        return habits.filter {
            return $0.isCompleted == false
        }
    }
    
    func add(habit: HabitVM.Habit) {
        let habitEntity = Habit(context: ctx)
        habitEntity.id = habit.id
        habitEntity.title = habit.title
        habitEntity.isCompleted = false
        habitEntity.imageName = habit.imageName
        
        Persistence.shared.save()
    }
    
    func toggleHabitCompletion(id: UUID) {
        let req: NSFetchRequest<Habit> = Habit.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let habitEntity = try ctx.fetch(req).first {
                habitEntity.isCompleted.toggle()
                Persistence.shared.save()
            }
        } catch {
            print("toggleHabitCompletion error:", error)
        }
    }
    
    func clearAll() {
        let request: NSFetchRequest<NSFetchRequestResult> = Habit.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try ctx.execute(deleteRequest)
            try ctx.save()
        } catch {
            print("Clean error:", error)
        }
    }
    
    func delete(id: UUID) {
        let request: NSFetchRequest<Habit> = Habit.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            if let ticket = try ctx.fetch(request).first {
                ctx.delete(ticket)
                try ctx.save()
                ctx.refreshAllObjects()
            }
        } catch {
            print("Delete error: \(error)")
        }
    }
    
    private func ticketsToTicketsVM(_ habits: [Habit]) -> [HabitVM.Habit] {
        var habitsVM: [HabitVM.Habit] = []
        for habit in habits {
            habitsVM.append(HabitVM.Habit(id: habit.id ?? UUID(),title: habit.title ?? "No name", imageName: habit.imageName ?? "default_task", isCompleted: habit.isCompleted))

        }
        return habitsVM
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

final class HabitRepositoryService {
    private let repo = HabitRepositoryWorker()
    private let ctx = Persistence.shared.container.viewContext
    
    func fetchAll() -> [HabitVM.Habit] { (try? repo.fetchAll()) ?? [] }
    func add(habit: HabitVM.Habit) { repo.add(habit: habit) }
    func delete(_ habit: HabitVM.Habit) { repo.delete(id: habit.id) }
    func fetchCompletedHabits() -> [HabitVM.Habit] {
        (try? repo.fetchCompletedHabits()) ?? []
    }
    func fetchNotCompletedHabits() -> [HabitVM.Habit] {
        (try? repo.fetchNotCompletedHabits()) ?? []
    }
}

