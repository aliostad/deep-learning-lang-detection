package tholowka.diz.unmarshalling.terms

import org.scalatest.FunSpec

class GeneralResourceLoadTest extends FunSpec {
    describe("** General test") {
    
        it("I can load proper.json file") {
            val json = load("proper.json")
            expect('{') {
                json(0)
            }
            expect('}') {
                json(1)
            }
        }

        it("I can load proper-multiline.json file") {
            val json = load("proper-multiline.json")
            expect('{') {
                json(0)
            }
            expect('}') {
                json(4)
            }
        }
    }
}
