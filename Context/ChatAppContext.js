import { React, createContext, useState, useEffect, useContext } from 'react'

import { useRouter } from 'next/router'

import {
  checkIfWalletIsConnected,
  connectWallet,
  connectingWithContract
} from '../Utils/apiFeatures'

export const ChatAppContext = createContext()

export const ChatAppProvider = ({ children }) => {
  const title = 'welcome'
  return (
    <ChatAppContext.Provider value={{title}}>{children}</ChatAppContext.Provider>
  )
}
