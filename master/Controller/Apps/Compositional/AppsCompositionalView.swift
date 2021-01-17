//
//  AppsCompositionalView.swift
//  master
//
//  Created by Zakirov Tahir on 04.01.2021.
//

import SwiftUI


class CompositionalController: UICollectionViewController {
    
    let headerId = "headerId"
    var socialApps = [SocialApp]()
    var games: AppGroup?
    var topGrossingApps: AppGroup?
    var feedApps: AppGroup?
    
    init() {
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                // функция вызывает и возрващает первую секцию
                return CompositionalController.topSection()
            } else {
                // вторая секция
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
                item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                section.orthogonalScrollingBehavior = .groupPaging
                
                // тут определяем шапку секции
                let kind = UICollectionView.elementKindSectionHeader
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)
                ]
                
                return section
            }
            
            
        }
        
        super.init(collectionViewLayout: layout)
    }
    
    // первая секция
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        
        return section
    }
    
    // класс для шапки
    class CompositionalHeader: UICollectionReusableView {
        
        let label = UILabel(text: "Топ тупого говна", font: .boldSystemFont(ofSize: 32))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(label)
            label.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.backgroundColor = .systemBackground
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView.register(AppRowCell.self, forCellWithReuseIdentifier: "smallCellId")
        
        navigationItem.rightBarButtonItem = .init(title: "Запросить топ free", style: .plain, target: self, action: #selector(handleFetchTopFree))
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
//        fetchApps()
        setupDiffableDatasourse()
        
    }
    
    @objc fileprivate func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        
        snapshot.deleteSections([.topFree, .freeGames, .grossing])
        
        diffableDataSource.apply(snapshot)
    }
    
    @objc fileprivate func handleFetchTopFree() {
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, error) in
            
            var snapshot = self.diffableDataSource.snapshot()
            
            snapshot.insertSections([.topFree], afterSection: .topSocial)
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
            
            self.diffableDataSource.apply(snapshot)
        }
    }
    
    enum AppSection {
        case topSocial
        case grossing
        case freeGames
        case topFree
    }
    
    // Работаем с UICollectionViewDiffableDataSource
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            
            cell.app = object
            
            return cell
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
            
            cell.app = object
            
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            
            return cell
        }
        
        return nil
    }
    
    @objc func handleGet(button: UIView) {
        var superview = button.superview
        
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                guard let objectClicked = diffableDataSource.itemIdentifier(for: indexPath) else { return }
                
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectClicked])
                diffableDataSource.apply(snapshot)
                
                
            }
            superview = superview?.superview
        }
        
       
    }
    
    // Сообщает делегату, что выбран элемент по указанному пути индекса.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        
        if let object = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        } else if let object = object as? FeedResult {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
        
        
    }
    
    private func setupDiffableDatasourse() {

        // Добавляем данные
        collectionView.dataSource = diffableDataSource
        
        // Замыкание, которое настраивает и возвращает дополнительные представления представления коллекции, такие как верхние и нижние колонтитулы, из источника дифференциальных данных
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            let section = snapshot.sectionIdentifier(containingItem: object!)!
            
            if section == .freeGames {
                header.label.text = "Бесплатные игры"
            } else if section == .grossing {
                header.label.text = "Топ платных игр"
            } else {
                header.label.text = "Топ бесплатных игр"
            }

            return header
        })
        
        Service.shared.fetchSodialApps { (socialApps, error) in
            
            Service.shared.fetchTopGrossing { (appGroup, error) in
                
                Service.shared.fetchGames { (gamesGroup, error) in
                    var snapshot = self.diffableDataSource.snapshot()
                    
                    // top social
                    snapshot.appendSections([.topSocial, .grossing, .freeGames])
                    snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
                    
                    // top grossing
                    let objects = appGroup?.feed.results ?? []
                    snapshot.appendItems(objects, toSection: .grossing)
                    
                    // top free
                    
                    snapshot.appendItems(gamesGroup?.feed.results ?? [], toSection: .freeGames)
                    
                    self.diffableDataSource.apply(snapshot)
                }
            }
            
            
        }
        
    }
    
    //
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
        var title: String?
        if indexPath.section == 1 {
            title = games?.feed.title
        } else if indexPath.section == 2 {
            title = topGrossingApps?.feed.title
        } else {
            title = feedApps?.feed.title
        }
        header.label.text = title
        return header
    }
    
    // срабатывает при касании на ячейку, в данном случае открывает детальную инфу
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let appId: String
//        if indexPath.section == 0 {
//            appId = socialApps[indexPath.item].id
//        } else if indexPath.section == 1 {
//            appId = games?.feed.results[indexPath.item].id ?? ""
//        } else if indexPath.section == 2 {
//            appId = topGrossingApps?.feed.results[indexPath.item].id ?? ""
//        } else {
//            appId = feedApps?.feed.results[indexPath.item].id ?? ""
//        }
//
//        let appDetailController = AppDetailController(appId: appId)
//        navigationController?.pushViewController(appDetailController, animated: true)
//
//    }
    
    // работа с сетью
    private func fetchApps() {
        Service.shared.fetchSodialApps { (apps, error) in
 
            // в переменную socialApps присваиваем данные из apps
            self.socialApps = apps ?? []
            
            Service.shared.fetchGames { (appGroup, error) in
                self.games = appGroup
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func fetchAppsDispatchGroup() {
        let dispathGroup = DispatchGroup()
        
        dispathGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            self.games = appGroup
            dispathGroup.leave()
        }
        
        dispathGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            self.topGrossingApps = appGroup
            dispathGroup.leave()
        }
        
        dispathGroup.enter()
        Service.shared.fetchAppGroup(urlString: "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json") { (appGroup, error) in
            self.feedApps = appGroup
            dispathGroup.leave()
        }
        
        dispathGroup.enter()
        Service.shared.fetchSodialApps { (apps, error) in
            dispathGroup.leave()
            self.socialApps = apps ?? []
        }
        
    }
    
    // сколько секции?
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
    // ячеек в секции
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return socialApps.count
//        } else if section == 1 {
//            return games?.feed.results.count ?? 0
//        } else if section == 2 {
//            return topGrossingApps?.feed.results.count ?? 0
//        } else {
//            return feedApps?.feed.results.count ?? 0
//        }
//    }
    
    // распределяем данные по секциям
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        switch indexPath.section {
//        case 0:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
//            // Распарсенные данные, сохраненные в переменной socialApps, распределяем по своим ярлыкам
//            cell.app = self.socialApps[indexPath.item]
//
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppRowCell
//            var appGroup: AppGroup?
//            if indexPath.section == 1 {
//                appGroup = games
//            } else if indexPath.section == 2 {
//                appGroup = topGrossingApps
//            } else {
//                appGroup = feedApps
//            }
//            cell.app = appGroup?.feed.results[indexPath.item]
//            return cell
//        }
//
//
//    }
    
    
}

// Структуры для вывода preview
struct AppsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = CompositionalController()
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
}

struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
}
