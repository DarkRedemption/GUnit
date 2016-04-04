local pendingCode = "__GUNIT_PENDING"

function GUnit.pending()
  assert(false, pendingCode)
end

GUnit.pendingCode = pendingCode