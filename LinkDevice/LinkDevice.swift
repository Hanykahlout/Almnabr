//
//  LinkDevice.swift
//  LinkDevice
//
//  Created by Hany Alkahlout on 19/09/2022.
//  Copyright © 2022 Samar Akkila. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct LinkDeviceEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {

            Color.init("AccentColor")

            VStack{
                HStack{
                    Spacer()
                        
                    Image("ItunesArtwork")
                        
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 22, height: 22, alignment: .center)
                        .foregroundColor(.white)
                        .cornerRadius(4)
                        .clipped()
                        
                }
                .padding(10)
                Image("qr-code")
                
                    .resizable()
                    .frame(width: 40, height: 40, alignment: .center)
                    .foregroundColor(.white)
                
                Text("Link Device").foregroundColor(.white)
                    .font(Font.custom("DroidKufi-Regular", size: 14))
                Spacer()
            }
            
        }
        .widgetURL(URL(string: "widget-deeplink://")!)
    }
    
}


@main
struct LinkDevice: Widget {
    let kind: String = "LinkDevice"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            LinkDeviceEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct LinkDevice_Previews: PreviewProvider {
    static var previews: some View {
        LinkDeviceEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
