// https://github.com/Quick/Quick

import Nimble
@testable import ObjectWrapper
import Quick

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("Collection tests") {
            it("it should expressible with dictionary") {
                let dict: Wrap = ["nested-dict": ["response": [1, 2, 3, 4]]]
                expect(dict["nested-dict"]?["response"]?[2]?.int).to(equal(3))
            }
            
            it("it should expressible with array") {
                let array: Wrap = [1, 2.0, "3", [4], ["D": 5.0]]
                
                expect(array[0]?.int).to(equal(1))
                expect(array[1]?.float).to(equal(2.0))
                expect(array[2]?.string).to(equal("3"))
                expect(array[3]?[0]).to(equal(4))
                
                //Wrap.double can comparable with native float
                expect(array[4]?["D"]).to(equal(5.0))
                
                expect([1, 2.0, "3", [4], ["D": 5.0]].count).to(equal(array.count))
            }
            
            it("should deal with deeply nested collections") {
                let nested: Wrap = ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["a": ["y"]]]]]]]]]]]]]]]]]]]]
                
                var deepCount = 0
                var current: Wrap = nested
                
                while let nest = current["a"] {
                    current = nest
                    deepCount = deepCount + 1
                }
                
                expect(current[0]).to(equal("y"))
                expect(deepCount).to(equal(19))
            }
        }
        
        describe("Compare tests") {
            it("should equal with native array") {
                let array: Wrap = [4]
                expect([4]).to(equal(array))
            }
            
            it("should equal with native dictionary") {
                let dict: Wrap = ["D": 5.0, "array": [4]]
                expect(["D": 5.0, "array": [4]]).to(equal(dict))
            }
            
            it("should equal with basic values") {
                expect(Wrap.float(3.0)).to(equal(.float(3.0)))
                expect(Wrap.int(3)).to(equal(.int(3)))
                expect(Wrap.bool(true)).to(equal(.bool(true)))
                expect(Wrap.array([])).to(equal(Wrap.array([])))
                expect(Wrap.dictionary([:])).to(equal(Wrap.dictionary([:])))
                
                expect(Wrap.float(3.0)).notTo(equal(.int(3)))
                expect(Wrap.float(1.0)).notTo(equal(.bool(true)))
                expect(Wrap.float(0.0)).notTo(equal(.bool(true)))
                expect(Wrap.float(1.0)).notTo(equal(.bool(false)))
                expect(Wrap.float(0.0)).notTo(equal(.bool(false)))
                expect(Wrap.int(0)).notTo(equal(.bool(true)))
                expect(Wrap.int(1)).notTo(equal(.bool(true)))
                expect(Wrap.int(0)).notTo(equal(.bool(false)))
                expect(Wrap.int(1)).notTo(equal(.bool(false)))
                
                expect(Wrap.string("3.0")).to(equal("3.0"))
                expect(Wrap.string("😊")).to(equal("😊"))
            }
        }
        
        describe("Deserialization tests") {
            it("should parse json string") {
                let source: Wrap = [
                    "name": "Sam Soffes",
                    "age": 24,
                    "salary": 150.000,
                    "retired": false
                ]
                
                let parsed = Wrap(usingJSON: "{ \"name\": \"Sam Soffes\",  \"age\": 24,  \"salary\": 150.000, \"retired\": false } ")
                
                expect(parsed).to(equal(source))
            }
        }
    }
}
