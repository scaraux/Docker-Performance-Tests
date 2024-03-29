
import Foundation

extension Dictionary {
    var jsonStringRepresentation: String? {
        guard let theJSONData = try? JSONSerialization.data(withJSONObject: self,
                                                            options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: theJSONData, encoding: .ascii)
    }
}

class Controller: EngineDelegate, CreateEnvironmentDelegate, LoadEnvironmentDelegate {

    var startIndexingDP: DispatchTime?
    var finishIndexingDP: DispatchTime?
    var startKGramDP: DispatchTime?
    var finishKGramDP: DispatchTime?
    var startWritingIndexDP: DispatchTime?
    var finishWritingIndexDP: DispatchTime?
    var startLoadingGramsDP: DispatchTime?
    var finishLoadingGramsDP: DispatchTime?

    var startQueriesDP: DispatchTime?
    var finishQueriesDP: DispatchTime?

    var totalWrites: Int = 0

    var path: URL!
    var queries: [String] = []
    var engine = Engine()
    var queryResults: [QueryResult]?
    var searchMode: Engine.SearchMode = .ranked
    var isQueryExecuting: Bool = false

    var queryTimeAccumulator: Double = 0.0

    init(atPath path: URL) {
        self.path = path
        self.configure();
    }

    func configure() {
        self.engine.delegate = self
        self.engine.initDelegate = self
        self.engine.loadDelegate = self
    }

    func computeElapsedTime(_ start: DispatchTime, _ end: DispatchTime) -> Double  {
        let diff = end.uptimeNanoseconds - start.uptimeNanoseconds
        let res =  Double(diff) / 1_000_000_000
        return res
    }

    func measurePerformance() {
        let totalReads = self.engine.getTotalReads()

        let indexingTime = computeElapsedTime(self.startIndexingDP!, self.finishIndexingDP!)
        let generateGramTime = computeElapsedTime(self.startKGramDP!, self.finishKGramDP!)
        let writeIndexTime = computeElapsedTime(self.startWritingIndexDP!, self.finishWritingIndexDP!)
        let loadTime = computeElapsedTime(self.startLoadingGramsDP!, self.finishLoadingGramsDP!)
        let queryTime = computeElapsedTime(self.startQueriesDP!, self.finishQueriesDP!)
        let averageQueryTime = self.queryTimeAccumulator / Double(self.queries.count)

        let measurements: [String: Any] = [
            "indexing_time": indexingTime,
            "generate_gram_index_time": generateGramTime,
            "write_index_to_disk_time": writeIndexTime,
            "load_index_to_ram_time" : loadTime,
            "number_queries_executed": self.queries.count,
            "average_query_response_time" : averageQueryTime,
            "total_reads_during_queries": totalReads,
            "total_writes_during_indexing": self.totalWrites,
            "query_time": queryTime
        ]

        print(measurements.jsonStringRepresentation!)

        exit(0)
    }

    func startTests(_ queries: [String]) {
        self.queries = queries
        self.createEnvironment()
    }

    func createEnvironment() {
        self.engine.newEnvironment(withPath: self.path)
    }

    func loadEnvironment() {
        self.engine.loadEnvironment(withPath: self.path)
    }

    func execQuery(_ query: String) {
        let startDP = DispatchTime.now()
        let results: [QueryResult]? = self.engine.execQuerySync(queryString: query, mode: .ranked)
        let endDP = DispatchTime.now()
        let elapsed = computeElapsedTime(startDP, endDP)
        self.queryTimeAccumulator += elapsed
    }

    func onEnvironmentLoaded() {
        self.startQueriesDP = DispatchTime.now()
        for query in self.queries {
            self.execQuery(query)
        }
        self.finishQueriesDP = DispatchTime.now()
        self.measurePerformance()
    }

    func onEnvironmentLoadingFailed(withError error: String) {
        print("Load env failed. Error: \(error)")
    }

    func onQueryResulted(results: [QueryResult]?) {}

    func onFoundSpellingCorrections(corrections: [SpellingSuggestion]) {}

    func onRequestApplySuggestion(suggestion: SpellingSuggestion) {}

    func onInitializationPhaseChanged(phase: CreateEnvironmentPhase, withTotalCount: Int) {
        if (phase == .phaseIndexingDocuments) {
            print("1. Indexing \(withTotalCount) documents.")
            self.startIndexingDP = DispatchTime.now()
        }
        if (phase == .phaseIndexingGrams) {
            print("2. Indexing \(withTotalCount) K-Grams.")
            self.finishIndexingDP = DispatchTime.now();
            self.startKGramDP = DispatchTime.now()
        }
        if (phase == .phaseWritingIndex) {
            print("3. Writing Index to disk.")
            self.finishKGramDP = DispatchTime.now()
            self.startWritingIndexDP = DispatchTime.now()
        }
        if (phase == .terminated) {
            self.totalWrites = self.engine.getTotalWrites()
            print("4. Indexing terminated successfully.")
            self.finishWritingIndexDP = DispatchTime.now()
            self.loadEnvironment()
        }
    }

    func onIndexingDocument(withFileName: String, documentNb: Int, totalDocuments: Int) {}

    func onIndexingGrams(forType: String, typeNb: Int, totalTypes: Int) {}

    func onLoadingPhaseChanged(phase: LoadEnvironmentPhase, withTotalCount: Int) {
        if (phase == .phaseLoadingGrams) {
            print("5. Loading K-Grams to RAM")
            startLoadingGramsDP = DispatchTime.now()
        }
        if (phase == .terminated) {
            print("6. Loading terminated.")
            finishLoadingGramsDP = DispatchTime.now()
        }
    }

    func onLoadingTypes(forGram: String, gramNb: Int, totalGrams: Int) {}

    func generateCurrentTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-YYYY-hh-mm-ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
}

let path = URL(fileURLWithPath: "./Corpus/Full_NationalParks/", isDirectory: true)
let controller = Controller(atPath: path)

let queries = [
    "natural park in forest",
    "crater lake",
    "advanced trips to lands",
    "magic in the green",
    "thousands of possibilities",
    "travel and more",
    "quietest place",
    "good place to rest and to meditate",
    "ocean facing hut",
]

controller.startTests(queries)

RunLoop.main.run()