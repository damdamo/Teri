# Teri (TErm RewrIting)

Teri is a library to term rewriting using strategies.
Based on ADT (Algebraic Data Type), Teri describes formally types with their corresponding operations.
Moreover, a term is evaluated using a strategy.
Strategies select the way of evaluate a term.

## How to use Teri ?

You need to create a dependency in your project.
Follow steps write [here](https://github.com/apple/swift-package-manager/blob/master/Documentation/Usage.md#defining-dependencies) to complete your *Package.swift* file.

Here an example of how to include Teri in your project:

```Swift
let package = Package(
    name: "MyTest",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(
            url: "https://github.com/damdamo/Teri.git",
            .branch("master")
        )
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MyTest",
            dependencies: ["Teri"]),
        .testTarget(
            name: "MyTestTests",
            dependencies: ["MyTest"]),
    ]
)
```
Now, you just need to import Teri in your swift file: `import Teri`

## How to write Terms

Terms which are already implemented with following operations are:

|         | Prefix | Generators    | Operations                  |
|---------|:------:|:-------------:|:----------------------------|
| Nat     | n      |*zero, succ*  |  *add(Nat,Nat), sub(Nat,Nat), eq(Nat,Nat)* |
| Boolean | b      | *true, false* | *not(Boolean), and(Boolean,Boolean), or(Boolean, Boolean)* |

Terms are implemented using Swift Enums.
The aim is to simplify the way to write terms.
Prefix are used to write a term.
If you write a Nat term, you have to write:  
`let t: Term = .n(...)`  
Same for Boolean term with *b* (Care, Boolean is not Bool type in Swift) !

Here a list of examples that you can write with Teri:

|                | Term  | Translate in Teri                   |
|----------------|:------|:-----------------------------------|
| Nat Example 1 | *zero*   | `let t: Term = .n(.zero)`          |
| Nat Example 2 | *succ(zero)*| `let t: Term = .n(.succ(.zero))`|
| Nat Example 3 | *add(succ(zero), x)* | `let t: Term = .n(.add(.succ(.zero), .var("x")))`|
| Boolean Example 1 | *true*   | `let t: Term = .b(.true)`          |
| Boolean Example 2 | *not(true)*| `let t: Term = .b(.not(.true))`|
| Boolean Example 3 | *and(or(true, x), true))* | `let t: Term = .b(.and(.or(.true,.var("x")), .true))`|

Thanks to the Swift type inference that gives you the possibility to write: `.n(.succ(.zero))` instead of `Term.n(Nat.succ(Nat.zero))`.

Teri adds the possibility to manipulate variables, which are written as `.var("nameOfTheVariable")`, for all types.
The name of the variable is a simple String in Swift.

If you want to see more examples, you can go directly inside: `Tests/TeriTests/TeriNatTests.swift`.

To help the final readability, the `CustomStringConvertible` protocol has been added and completed for all types, to have a pretty print for terms.
Try to print terms to see the result !
For example: `print(Term.b(.and(.or(.true,.var("x")), .true)))
` returns `(true ∨ x) ∧ true`.

## How to evaluate Terms ?

Evaluate terms needs to select an order to reduce all of them.
For instance, let suppose the term: *add(add(x,zero),zero)*.
Should we reduce from inside (*innermost*) or outside (*outermost*) ?
- *Innermost*: *add(sub(x,zero),zero)* --> *add(x,zero)* --> *x*
- *Outermost*: *add(sub(x,zero),zero)* --> *sub(x,zero)* --> *x*

In Teri:
```Swift
let t: Term = .n(.add(.add(.var("x"), .zero), .zero))
// Innermost strategy:
// Print: Optional(x)
print(t.eval(s: .innermost(.axiom)))
// Outermost strategy
// Print: Optional(x)
print(t.eval(s: .outermost(.axiom)))
```

Strategies can fail, for this reason the return result is *Optional*.
If it fails, the result value is *nil*.

In this sort example, the final answer is the same.
However, it will not be the case everytime.

Another example with *add(add(zero,zero), add(zero,zero))*:
- *Innermost*: *add(add(zero,zero), add(zero,zero))* --> *zero*
- *Outermost*: *add(add(zero,zero), add(zero,zero))* --> *add(zero,zero)*

Strategies can be combined as you wish.
Here a list of all strategies which are implemented:
(t is the term to evaluate)
- **identity**: (Identity)[t] = t (returns the term)
- **fail**: (Fail)[t] = fail
- **axiom**: Rewrite the term with the first axiom that matches
- **sequence**:
  - (s1)[t] = fail => (Sequence(s1,s2))[t] = fail (If the first strategy fails, everything fails)
  - (s1)[t] = t' => (Sequence(s1,s2))[t] = (s2)[t]
- **choice**:
  - (s1)[t] = t' => (Choice(s1,s2))[t] = t'
  - (s1)[t] = fail => (Choice(s1,s2))[t] = (s2)[t] (If the first strategy fails, returns the result of the second)
- **all**:
  - (s)[t1] = t1', ..., (s)[tn] = tn' => (All(s))[f(t1,...,tn)] = f(t1',...,tn') (Rewrite direct subterms of f)
  - ∃i, (s)[ti] = fail => (All(s))[f(t1,...,tn)] = fail (If there exists at least one subterm that fails with the strategy, the whole strategy fails)
  - (All(s))[cst] = cst
- **try**: Try(s) = Choice(s, Identity)
- **innermost**: Innermost(s) = μx.Sequence(All(Innermost(x)), Try(Sequence(s,x))) (Strategy which consists to evaluate all subterms before to evaluate the outer term, and apply it recursively)
- **outermost**: Outermost(s) = μx.Sequence(Try(Sequence(s,x)), All(Innermost(x))) (Same logic that *innermost* but goes from outside to inside)

### Done :

- ADTs:
  - Nat
  - Boolean
- Rewriting rules
- Rewriting strategies
- Basics unit test cases

### TODO List :

- Equational proof/theory:
  - Reflexivity
  - Symmetry
  - Transitivity
  - ...
