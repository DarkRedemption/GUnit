local asserts = {}

--Asserts that a function should fail.
function asserts.shouldFail(func, ...)
  local args = {...}
  local successful, _ = pcall(func, unpack(args))
  assert(!successful, "Function did not fail.")
end

GUnit.Asserts = asserts