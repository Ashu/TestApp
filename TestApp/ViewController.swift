//
//  ViewController.swift
//  TestApp
//
//  Created by Ashu on 17/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private var searchBarTopConstraint: NSLayoutConstraint!
    private var searchBarPinned = false
    
    
    private let allData: [String] = Array(repeating: "List item title", count: 20)
    var filteredData: [String]!
    
    let carouselData: [UIImage] = {
        return (0...7).compactMap { UIImage(named: "image-\($0)")}
    }()
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        searchBar.delegate = self
        setupCollectionView()
        setupPageControl()
        setupTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatedScrollViewContentSize()
    }
    
    func setupCollectionView() {
        carouselCollectionView.register(UINib(nibName: CarouselCell.cellID, bundle: .main), forCellWithReuseIdentifier: CarouselCell.cellID)
        carouselCollectionView.showsHorizontalScrollIndicator = false
        carouselCollectionView.dataSource = self
        carouselCollectionView.delegate = self
        carouselCollectionView.isPagingEnabled = true
        
        let cellWidth = carouselCollectionView.frame.width - 32
        let cellPadding = (carouselCollectionView.frame.width - cellWidth) / 2
        let carouselLayout = UICollectionViewFlowLayout()
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = .init(width: cellWidth, height: 200)
        carouselLayout.sectionInset = .init(top: 0, left: cellPadding, bottom: 0, right: cellPadding)
        carouselLayout.minimumLineSpacing = cellPadding * 2
        carouselCollectionView.collectionViewLayout = carouselLayout
    }
    
    func setupPageControl() {
        pageControl.pageIndicatorTintColor = .systemGray
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.numberOfPages = carouselData.count
    }
    
    func setupTableView() {
        filteredData = allData
        tableView.register(UINib(nibName: TableViewCell.cellID, bundle: .main), forCellReuseIdentifier: TableViewCell.cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
    
    func updatedScrollViewContentSize() {
        scrollView.isScrollEnabled = true
        let totalHeight = carouselCollectionView.frame.height + pageControl.frame.height + pageControl.frame.height + CGFloat(20 * 80) + 16
        scrollView.contentSize = CGSize(width: view.frame.width, height: totalHeight)
        
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carouselData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.cellID, for: indexPath) as? CarouselCell else {
            return UICollectionViewCell()
        }
        cell.configure(image: carouselData[indexPath.row])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == carouselCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = page
        }
        
        if scrollView == scrollView {
            
            let searchBarFrameInSuperview = searchBar.convert(searchBar.bounds, to: self.view)
            
            if searchBarFrameInSuperview.origin.y <= view.safeAreaInsets.top {
                searchBar.transform = CGAffineTransform(translationX: 0, y: scrollView.contentOffset.y - searchBar.frame.origin.y + view.safeAreaInsets.top)
            } else {
                searchBar.transform = .identity
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.cellID, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: UIImage(named: "image-1"),
                       title: filteredData[indexPath.row],
                       subtitle: "List item subtitle")
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? allData : allData.filter({(dataString: String) -> Bool in
            return dataString.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
}
