//
//  ContentView.swift
//  RemainerApp
//
//  Created by Akhil Suresh on 2020-12-01.
//  Copyright © 2020 Akhil Suresh. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // @Environment is great for reading out things like a Core Data managed object context, whether the device is in dark mode or light mode, what size class your view is being rendered with, and more – fixed properties that come from the system.
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Tasks.entity(), sortDescriptors:[]) var task: FetchedResults<Tasks>
    //Fetch requests allow us to load Core Data results that match specific criteria we specify, and SwiftUI can bind those results directly to user interface elements.
    
    
    //Restart the xcode if tasks is not highlighed
    //wrap the property in @State when it is going to change
    @State private var newTaskName = ""
    
    //and connect it to the textfield
    
    // create a placeholder property for updating
    @State private var selectedTask: Tasks?
    
    //For each task output the name of the task as a text in a textfield
    //VStack renders the view all at once 
    var body: some View {
        VStack{
            TextField("Add new", text: self.$newTaskName).multilineTextAlignment(.center)
            Button("Save"){self.Save(tasks: self.selectedTask)}
            List{
            ForEach(task, id: \.self){ tasks in
                Text("\(tasks.name!)")
                    .onTapGesture {
                        self.newTaskName = tasks.name!
                        self.selectedTask = tasks
                }
                }
            .onDelete{IndexSet in
                for index in IndexSet{
                    
                    self.context.delete(self.task[index])
                    try? self.context.save()
                }
                
                }
            }
        
 
        }
    }
    
    
    func Save(tasks: Tasks?){
        if self.selectedTask == nil{
        let newTask = Tasks(context:self.context)
        newTask.name = newTaskName
        try? self.context.save()
        }
        else{
            //since this may take extra time to peroform wrap it in a perform and wait
            context.performAndWait {
                
                tasks!.name = self.newTaskName
                try? context.save()
                self.newTaskName = ""
                self.selectedTask = nil
            }
            
            
        }
        
    }
    
    
}




