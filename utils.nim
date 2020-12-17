import lists, sequtils, strutils, sugar

proc digits*(integer: int, base: int = 10): SinglyLinkedList[int] =
  var acc = initSinglyLinkedList[int]()
  var digits = integer
  while true:
    if abs(digits) < base:
      acc.prepend(digits)
      return acc
    acc.prepend(digits mod base)
    digits = digits div base

proc letterize*(integer: int): string =
  var
    digits = integer.digits(26)
    letterSeq = toSeq 'a'..'z'
  let letters = collect(newSeq):
    for d in digits.nodes:
      if d.next.isNil():
        letterSeq[d.value]
      else:
        letterSeq[d.value - 1]


  return letters.join("")
