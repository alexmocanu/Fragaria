//
//  MGSFragariaPrivate.h
//  Fragaria
//
//  Created by Daniele Cattaneo on 24/02/15.
//
//

@class MGSExtraInterfaceController;
@class MGSSyntaxErrorController;
@class SMLSyntaxColouring;
@class MGSLineNumberDefaultsObserver;
@class MGSLineNumberView;
@class MGSTemporaryPreferencesObserver;

#pragma mark - Class Extension


@interface MGSFragaria()


#pragma mark - System Components


/** The controller responsible for managing accessory dialogs for this instance
 * of MGSFragaria. */
@property (nonatomic, readwrite) MGSExtraInterfaceController *extraInterfaceController;

/** The controller which manages and displays the syntax errors in Fragaria's
 * text view and gutter view. */
@property (nonatomic, strong, readwrite) MGSSyntaxErrorController *syntaxErrorController;

/** Instances of this class will perform syntax highlighting in text views. */
@property (nonatomic, strong, readwrite) SMLSyntaxColouring *syntaxColouring;

/** The observer which manages the properties of MGSLineNumberView. Will be
 * removed in the near future. */
@property MGSLineNumberDefaultsObserver *lineNumberDefObserv;

/** Fragaria's left ruler. Handles display of line numbers, breakpoints and
 * syntax error badges. */
@property MGSLineNumberView *gutterView;

/** Fragaria's scroll view. */
@property (nonatomic, strong) NSScrollView *scrollView;

/** Fragaria's scroll view. */
@property (nonatomic, strong) SMLTextView *textView;


/** Fragaria's *temporary* preferences obsever. */
@property (nonatomic, strong) MGSTemporaryPreferencesObserver *temporaryPreferencesObserver;

@end

