//
//  PostAdd.swift
//  stayConnected-iOS
//
//  Created by Despo on 30.11.24.
//

import UIKit

protocol PresentedVCDelegate: AnyObject {
  func didDismissPresentedVC()
}

class PostAdd: UIViewController, UITextFieldDelegate, DidTagsRefreshed, DidPostedSuccessfully, DidPostingFailed {
  weak var delegate: PresentedVCDelegate?
  private let viewModel: PostAddViewModel
  private let loadingIndicator: LoadingIndicator
  
  private let lineOne:UIView = {
    let lineView = UIView()
    lineView.translatesAutoresizingMaskIntoConstraints = false
    lineView.backgroundColor = .primaryGray
    return lineView
  }()
  
  private let lineTwo:UIView = {
    let lineView = UIView()
    lineView.translatesAutoresizingMaskIntoConstraints = false
    lineView.backgroundColor = .primaryGray
    return lineView
  }()
  
  private let lineThree:UIView = {
    let lineView = UIView()
    lineView.translatesAutoresizingMaskIntoConstraints = false
    lineView.backgroundColor = .primaryGray
    return lineView
  }()
  
  private lazy var headerBar: UIView = {
    let view = UIView()
    view.backgroundColor = .bgWhite
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var headerTitle: UILabel = {
    let label = UILabel()
    label.configureCustomText(
      text: "Add Question",
      color: .primaryBack,
      size: 16,
      weight: .regular
    )
    return label
  }()
  
  private lazy var cancelButton: UIButton = {
    let button = UIButton()
    button.configureCustomButton(
      title: "Cancel",
      color: .primaryViolet,
      fontName: "InterB",
      fontSize: 16
    )
    return button
  }()
  
  private lazy var subjectInput: UITextField = {
    let field = UITextField()
    field.translatesAutoresizingMaskIntoConstraints = false
    field.clipsToBounds = true
    field.keyboardType = .default
    
    let leftLabelContainer = UIView()
    leftLabelContainer.translatesAutoresizingMaskIntoConstraints = false
    
    let leftLabel = UILabel()
    leftLabel.translatesAutoresizingMaskIntoConstraints = false
    leftLabel.configureCustomText(
      text: "Subject: ",
      color: .primaryGray,
      size: 15,
      weight: .regular
    )
    leftLabelContainer.addSubview(leftLabel)
    
    let padding: CGFloat = 16
    let intrinsicWidth = leftLabel.intrinsicContentSize.width + padding
    
    NSLayoutConstraint.activate([
      leftLabel.leadingAnchor.constraint(equalTo: leftLabelContainer.leadingAnchor, constant: 8),
      leftLabelContainer.widthAnchor.constraint(equalToConstant: intrinsicWidth),
      leftLabelContainer.heightAnchor.constraint(equalToConstant: 47),
      leftLabel.centerYAnchor.constraint(equalTo: leftLabelContainer.centerYAnchor)
      
    ])
    
    field.leftView = leftLabelContainer
    field.leftViewMode = .always
    
    return field
  }()
  
  private lazy var tagInputView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let tagLabel: UILabel = {
    let label = UILabel()
    label.configureCustomText(
      text: "Tag: ",
      color: .primaryGray,
      size: 15,
      weight: .regular
    )
    return label
  }()
  
  private lazy var tagCollectionPostAdd: UICollectionView = {
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.scrollDirection = .horizontal
    collectionLayout.estimatedItemSize = CGSize(width: 100, height: 30)
    collectionLayout.minimumInteritemSpacing = 10
    let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
    collection.backgroundColor = .clear
    collection.delegate = self
    collection.dataSource = self
    collection.showsHorizontalScrollIndicator = false
    return collection
  }()
  
  private lazy var chooseTagCollection: UICollectionView = {
    let collectionLayout = UICollectionViewFlowLayout()
    collectionLayout.scrollDirection = .vertical
    collectionLayout.minimumLineSpacing = 10
    collectionLayout.minimumInteritemSpacing = 10
    collectionLayout.estimatedItemSize = CGSize(width: 100, height: 30)
    let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.register(TagCell.self, forCellWithReuseIdentifier: "TagCell")
    collection.backgroundColor = .clear
    collection.delegate = self
    collection.dataSource = self
    collection.showsVerticalScrollIndicator = false
    
    return collection
  }()
  
  private lazy var tagsStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    return stack
  }()
  
  let postInput = AddFieldReusable(placeHolder: "Type your question here")
  
  init(
    viewModel: PostAddViewModel = PostAddViewModel(),
    loadingIndicator: LoadingIndicator = LoadingIndicator()
  ) {
    self.viewModel = viewModel
    self.loadingIndicator = loadingIndicator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.setNavigationBarHidden(true, animated: false)
    viewModel.delegate = self
    viewModel.successDelegate = self
    viewModel.postingFailure = self
    
    setupUI()
  }
  
  override func viewIsAppearing(_ animated: Bool) {
    super.viewIsAppearing(animated)
    viewModel.fetchTags(api: EndpointsEnum.tags.rawValue)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if isBeingDismissed {
      delegate?.didDismissPresentedVC()
    }
  }
  
  private func setupUI() {
    view.backgroundColor = .primaryWhite
    postInput.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(lineOne)
    view.addSubview(lineTwo)
    view.addSubview(lineThree)
    view.addSubview(headerBar)
    view.addSubview(tagInputView)
    view.addSubview(chooseTagCollection)
    tagInputView.addSubview(tagLabel)
    tagInputView.addSubview(tagCollectionPostAdd)
    headerBar.addSubview(headerTitle)
    headerBar.addSubview(cancelButton)
    view.addSubview(subjectInput)
    view.addSubview(postInput)
    
    loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingIndicator)
    view.bringSubviewToFront(loadingIndicator)
    loadingIndicator.center = view.center
    
    setupConstraints()
    
    cancelButton.addAction(UIAction(handler: { [weak self] _ in
      self?.closeModal()
    }), for: .touchUpInside)
    
    postInput.translatesAutoresizingMaskIntoConstraints = false
    postInput.onSendAction = {[weak self] in
      self?.addPostToDataBase()
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      headerBar.heightAnchor.constraint(equalToConstant: 77),
      headerBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      headerBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      headerBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
      
      lineOne.heightAnchor.constraint(equalToConstant: 1),
      lineOne.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 0),
      lineOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      lineOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      
      headerTitle.centerXAnchor.constraint(equalTo: headerBar.centerXAnchor),
      headerTitle.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),
      
      cancelButton.centerYAnchor.constraint(equalTo: headerBar.centerYAnchor),
      cancelButton.trailingAnchor.constraint(equalTo: headerBar.trailingAnchor, constant: -32),
      
      subjectInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      subjectInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      subjectInput.topAnchor.constraint(equalTo: headerBar.bottomAnchor, constant: 0),
      subjectInput.widthAnchor.constraint(equalTo: view.widthAnchor),
      subjectInput.heightAnchor.constraint(equalToConstant: 47),
      
      lineTwo.heightAnchor.constraint(equalToConstant: 1),
      lineTwo.topAnchor.constraint(equalTo: subjectInput.bottomAnchor, constant: 0),
      lineTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      lineTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      
      tagInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      tagInputView.topAnchor.constraint(equalTo: lineTwo.bottomAnchor, constant: 0),
      tagInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      tagInputView.heightAnchor.constraint(equalToConstant: 47),
      
      tagLabel.leadingAnchor.constraint(equalTo: tagInputView.leadingAnchor, constant: 8),
      tagLabel.centerYAnchor.constraint(equalTo: tagInputView.centerYAnchor),
      
      tagCollectionPostAdd.leadingAnchor.constraint(equalTo: tagLabel.trailingAnchor, constant: 10),
      tagCollectionPostAdd.topAnchor.constraint(equalTo: tagInputView.topAnchor, constant: 0),
      tagCollectionPostAdd.trailingAnchor.constraint(equalTo: tagInputView.trailingAnchor, constant: 0),
      tagCollectionPostAdd.bottomAnchor.constraint(equalTo: tagInputView.bottomAnchor, constant: 0),
      
      lineThree.heightAnchor.constraint(equalToConstant: 1),
      lineThree.topAnchor.constraint(equalTo: tagCollectionPostAdd.bottomAnchor, constant: 0),
      lineThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
      lineThree.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
      
      chooseTagCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
      chooseTagCollection.topAnchor.constraint(equalTo: lineThree.topAnchor, constant: 10),
      chooseTagCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
      chooseTagCollection.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
      
      postInput.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      postInput.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      postInput.topAnchor.constraint(equalTo: chooseTagCollection.bottomAnchor, constant: 10),
      postInput.heightAnchor.constraint(equalToConstant: 47),
      
      loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  func closeModal() {
    dismiss(animated: true , completion: nil )
  }
  
  private func addPostToDataBase() {
    let subjectValue = subjectInput.text
    let questionValue = postInput.value()
    
    loadingIndicator.startAnimating()
    
    guard subjectValue?.count ?? 0 > 0, questionValue.count > 0 else {
      return showAlert(title: "Let’s Fix This", message: "ill all fields", buttonTitle: "Try Again")
    }
    
    viewModel.attemptAddQuestion(api: EndpointsEnum.singelQuestion.rawValue, subject: subjectValue ?? "", question: questionValue)
  }
  
  func didTagsRefreshed() {
    chooseTagCollection.reloadData()
  }
  
  func didPostAddedSuccssfully() {
    showAlert(title: "Well, That Was Easy!", message: "Question added successfully", buttonTitle: "Ask one more?")
    subjectInput.text = ""
    postInput.clearInput()
    loadingIndicator.stopAnimating()
  }
  
  func didPostingFailed() {
    let error = viewModel.errorMessage
    showAlert(title: "Oh No!", message: error, buttonTitle: "Try Again")
    
  }
}


extension PostAdd: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    collectionView == tagCollectionPostAdd ? viewModel.activeTags.count : viewModel.inactiveTags.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as? TagCell
    let singleTag = collectionView == tagCollectionPostAdd ? viewModel.singleActiveTag(at: indexPath.row) : viewModel.singleInactiveTag(at: indexPath.row)
    
    cell?.configureWithName(with: singleTag.name)
    return cell ?? TagCell()
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == tagCollectionPostAdd {
      viewModel.removeActiveTag(at: indexPath.row)
      collectionView.deleteItems(at: [indexPath])
      chooseTagCollection.reloadData()
    } else {
      viewModel.removeInactiveTag(at: indexPath.row)
      collectionView.deleteItems(at: [indexPath])
      tagCollectionPostAdd.reloadData()
    }
  }
}
