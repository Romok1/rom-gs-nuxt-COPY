export default function (data) {
  if (typeof data !== 'object') {
    throw new TypeError('Form data function expects an object')
  }

  const formData = new FormData()

  for (const field in data) {
    if (data[field] !== undefined) {
      formData.append(field, data[field])
    }
  }

  return formData
}
