import React, { useState, useEffect, useContext } from 'react'

import { ChatAppContext } from '../Context/ChatAppContext'

const  chatApp = () => {
  const x = useContext(ChatAppContext)
  console.log(x)
  
  return <div>hello</div>
}

export default chatApp