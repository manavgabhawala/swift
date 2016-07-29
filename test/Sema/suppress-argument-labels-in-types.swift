// RUN: %target-swift-frontend -module-name TestModule -parse -verify -suppress-argument-labels-in-types %s

// Test non-overloaded global function references.
func f1(a: Int, b: Int) -> Int { }

func testF1(a: Int, b: Int) {
  _ = f1(a: a, b: a) // okay: direct call requires argument labels
  _ = (f1)(a: a, b: a) // okay: direct call requires argument labels
  _ = ((f1))(a: a, b: a) // okay: direct call requires argument labels

  _ = f1(a:b:)(1, 2) // compound name suppresses argument labels

  let _: Int = f1    // expected-error{{cannot convert value of type '(Int, Int) -> Int' to specified type 'Int'}}
}

// Test multiple levels of currying.
func f2(a: Int, b: Int) -> (Int) -> (Int) -> Int { }

func testF2(a: Int, b: Int) {
  _ = f2(a: a, b: b)(a) // okay: direct call requires argument labels
  _ = f2(a: a, b: b)(a)(b) // okay: direct call requires argument labels
}

// Check throwing functions.
func f3(a: Int, b: Int) throws -> Int { }

func testF3(a: Int, b: Int) {
  do {
  _ = try f3(a: a, b: a) // okay: direct call requires argument labels
  _ = try (f3)(a: a, b: a) // okay: direct call requires argument labels
  _ = try ((f3))(a: a, b: a) // okay: direct call requires argument labels

  _ = try f3(a:b:)(1, 2) // compound name suppresses argument labels

    let i: Int = f3    // expected-error{{cannot convert value of type '(Int, Int) throws -> Int' to specified type 'Int'}}

    _ = i
  } catch {
  } 
}

// Test overloaded global function references.
func f4(a: Int, b: Int) -> Int { }
func f4(c: Double, d: Double) -> Double { }

func testF4(a: Int, b: Int, c: Double, d: Double) {
  _ = f4(a: a, b: a) // okay: direct call requires argument labels
  _ = (f4)(a: a, b: a) // okay: direct call requires argument labels
  _ = ((f4))(a: a, b: a) // okay: direct call requires argument labels
  _ = f4(c: c, d: d) // okay: direct call requires argument labels
  _ = (f4)(c: c, d: d) // okay: direct call requires argument labels
  _ = ((f4))(c: c, d: d) // okay: direct call requires argument labels

  _ = f4(a:b:)(1, 2) // compound name suppresses argument labels
  _ = f4(c:d:)(1.5, 2.5) // compound name suppresses argument labels

  let _: (Int, Int) -> Int = f4
  let _: (Double, Double) -> Double = f4
  
  // Note: these will become ill-formed when the rest of SE-0111 is
  // implemented. For now, they check that the labels were removed by the type
  // system.
  let _: (x: Int, y: Int) -> Int = f4
  let _: (x: Double, y: Double) -> Double = f4
}

// Test module-qualified function references.
func testModuleQualifiedRef(a: Int, b: Int, c: Double, d: Double) {
  _ = TestModule.f1(a: a, b: a) // okay: direct call requires argument labels
  _ = (TestModule.f1)(a: a, b: a) // okay: direct call requires argument labels
  _ = ((TestModule.f1))(a: a, b: a) // okay: direct call requires argument labels

  _ = TestModule.f1(a:b:)(1, 2) // compound name suppresses argument labels

  let _: Int = TestModule.f1    // expected-error{{cannot convert value of type '(Int, Int) -> Int' to specified type 'Int'}}

  _ = TestModule.f4(a: a, b: a) // okay: direct call requires argument labels
  _ = (TestModule.f4)(a: a, b: a) // okay: direct call requires argument labels
  _ = ((TestModule.f4))(a: a, b: a) // okay: direct call requires argument labels
  _ = TestModule.f4(c: c, d: d) // okay: direct call requires argument labels
  _ = (TestModule.f4)(c: c, d: d) // okay: direct call requires argument labels
  _ = ((TestModule.f4))(c: c, d: d) // okay: direct call requires argument labels

  _ = TestModule.f4(a:b:)(1, 2) // compound name suppresses argument labels
  _ = TestModule.f4(c:d:)(1.5, 2.5) // compound name suppresses argument labels

  let _: (Int, Int) -> Int = TestModule.f4
  let _: (Double, Double) -> Double = TestModule.f4

  // Note: these will become ill-formed when the rest of SE-0111 is
  // implemented. For now, they check that the labels were removed by the type
  // system.
  let _: (x: Int, y: Int) -> Int = TestModule.f4
  let _: (x: Double, y: Double) -> Double = TestModule.f4
}

// Test member references.
struct S0 {
  init(a: Int, b: Int) { }

  func f1(a: Int, b: Int) -> Int { }
  func f2(a: Int, b: Int) -> (Int) -> (Int) -> Int { }

  func f4(a: Int, b: Int) -> Int { }
  func f4(c: Double, d: Double) -> Double { }

  subscript (a a: Int, b b: Int) -> Int {
    get { }
    set { }
  }
}

func testS0Methods(s0: S0, a: Int, b: Int, c: Double, d: Double) {
  _ = s0.f1(a: a, b: a) // okay: direct call requires argument labels
  _ = (s0.f1)(a: a, b: a) // okay: direct call requires argument labels
  _ = ((s0.f1))(a: a, b: a) // okay: direct call requires argument labels

  _ = s0.f1(a:b:)(a, b) // compound name suppresses argument labels

  let _: Int = s0.f1    // expected-error{{cannot convert value of type '(Int, Int) -> Int' to specified type 'Int'}}

  _ = s0.f2(a: a, b: b)(a) // okay: direct call requires argument labels
  _ = s0.f2(a: a, b: b)(a)(b) // okay: direct call requires argument labels

  _ = s0.f4(a: a, b: a) // okay: direct call requires argument labels
  _ = (s0.f4)(a: a, b: a) // okay: direct call requires argument labels
  _ = ((s0.f4))(a: a, b: a) // okay: direct call requires argument labels
  _ = s0.f4(c: c, d: d) // okay: direct call requires argument labels
  _ = (s0.f4)(c: c, d: d) // okay: direct call requires argument labels
  _ = ((s0.f4))(c: c, d: d) // okay: direct call requires argument labels

  _ = s0.f4(a:b:)(1, 2) // compound name suppresses argument labels
  _ = s0.f4(c:d:)(1.5, 2.5) // compound name suppresses argument labels

  let _: (Int, Int) -> Int = s0.f4
  let _: (Double, Double) -> Double = s0.f4

  // Note: these will become ill-formed when the rest of SE-0111 is
  // implemented. For now, they check that the labels were removed by the type
  // system.
  let _: (x: Int, y: Int) -> Int = s0.f4
  let _: (x: Double, y: Double) -> Double = s0.f4
}

// Curried instance methods.
func testS0CurriedInstanceMethods(s0: S0, a: Int, b: Int) {
  _ = S0.f1(s0)(a: a, b: a)  // okay: direct call requires argument labels
  _ = (S0.f1)(s0)(a: a, b: a) // okay: direct call requires argument labels
  _ = ((S0.f1))(s0)(a: a, b: a) // okay: direct call requires argument labels

  _ = S0.f1(a:b:)(s0)(a, b) // compound name suppresses argument labels

  let _: Int = S0.f1    // expected-error{{cannot convert value of type '(S0) -> (Int, Int) -> Int' to specified type 'Int'}}
  let f1OneLevel = S0.f1(s0)
  let _: Int = f1OneLevel // expected-error{{cannot convert value of type '(Int, Int) -> Int' to specified type 'Int'}}
}

// Initializers.
func testS0Initializers(s0: S0, a: Int, b: Int) {
  let _ = S0(a: a, b: b)  // okay: direct call requires argument labels
  let _ = S0.init(a: a, b: b)  // okay: direct call requires argument labels

  let _ = S0.init(a:b:)(a, b) // compound name suppresses argument labels

  // Curried references to the initializer drop argument labels.
  let s0c1 = S0.init
  let _: Int = s0c1 // expected-error{{cannot convert value of type '(Int, Int) -> S0' to specified type 'Int'}}

  let s0c2 = S0.init(a:b:)
  let _: Int = s0c2 // expected-error{{cannot convert value of type '(Int, Int) -> S0' to specified type 'Int'}}
}

func testS0Subscripts(s0: S0, a: Int, b: Int) {
  let _ = s0[a: a, b: b]

  var s0Var = s0
  s0Var[a: a, b: b] = a
}